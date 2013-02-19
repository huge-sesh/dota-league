import ircutils.bot, traceback, json, pprint, requests
API_URL = 'http://localhost:3000'
channel = '#seshdota'
name = 'dotabot'

class Bot(ircutils.bot.SimpleBot):
  def send_message(self, target, message):
    for line in message.split('\n'): 
      super(ircutils.bot.SimpleBot, self).send_message(target, str(line))
  def on_channel_message(self, event):
    self.command(event, False)
  def on_private_message(self, event):
    self.command(event, True)

  def init(self):
    self.users = {}
    self.printer = Printer()
    self.initted = True
    self.api = {
      '?help'    : {'help': 'print this help string', 'call': self.help},
      '!token'   : {'help': 'login using your token from %s/users/token '
        'you must call this before issuing most other commands' % API_URL, 'call': self.token},
      '!enqueue' : {'help': 'add yourself to the queue', 'call': self.call, 'method': 'post', 'endpoint': '/users/enqueue'},
      '!dequeue' : {'help': 'remove yourself from the queue', 'call': self.call, 'method': 'post', 'endpoint': '/users/dequeue'},
      '!accept'  : {'help': 'accept an offered game', 'call': self.call, 'method': 'post', 'endpoint': '/users/accept'},
      '!decline' : {'help': 'decline an offered game and dequeue', 'call': self.call, 'method': 'post', 'endpoint': '/users/decline'},
      '!report'  : {'help': 'report the result of a game. format: report [id:game_id] radiant_victory:(true/false). mod-only', 
        'call':self.call, 'method':'post', 'endpoint': '/games/report' },
      '?queue'   : {'help': 'show the current queue', 'call': self.call, 'method': 'get', 'endpoint': '/users/queue'},
      '?games'   : {'help': 'show the current games', 'call': self.call, 'method': 'get', 'endpoint': '/games'},
    }

  def command(self, event, private):
    if not hasattr(self, 'initted'): self.init()
    try: 
      command = event.message.split()
      target = channel if event.target == channel else event.source
      print 'command', event.source, event.target, command
      if command[0] in self.api:
        args = [arg for arg in command[1:] if len(arg.split(':')) == 1]
        kwargs = dict([arg.split(':') for arg in command[1:] if len(arg.split(':')) == 2])
        result = self.api[command[0]]['call'](event, *args, private=private, **dict(kwargs.items() + self.api[command[0]].items()))
        if result: self.send_message(target, self.printer.process(result))
      elif command[0][0] in ('!', '?'):
        self.send_message(target, '%s is not a valid command' % command[0])

    except Exception:
      traceback.print_exc()

  def call(self, event, **kwargs):
    print 'calling', kwargs['endpoint']
    if not event.source in self.users:
      self.send_message(event.source, 'use !token [token] to log in before issuing commands. use ?help for more information')
      return
    return json.loads(getattr(requests, kwargs['method'])(API_URL + kwargs['endpoint'] +'.json', params = {'token':self.users[event.source]}).text)

  def help(self, event, **kwargs):
    self.send_message(event.source, 'Using dotabot:'
      '\n  If you have not already done so, register an account at %s.'
      '\n  Then, obtain your token from %s/users/token and login using !token [web token]'
      '\n  Use !enqueue to join the queue, when there are ten players queued a game will be offered'
      '\n  Use !accept to accept the game. When all players have accepted, you will be told the lobby password and your team'
      '\nCommands: '
      + (''.join(['\n  %s: %s' % (key, value['help']) for key, value in self.api.iteritems()])))

  def token(self, event, token, **kwargs):
    if not kwargs['private']:
      self.send_message(event.source, 'dont post your token in a public place. it lets people impersonate you. resetting your token.')
      result = json.loads(requests.post(API_URL + '/users/reset_token.json', params = {'token':token}).text)
      token = result['token']
      self.send_message(event.source, 'reset your token to %s' % token)
    self.users[event.source] = token
    self.send_message(event.source, 'logged you in, %s' % event.source)

class Printer(object):
  def process(self, data):
    pprint.pprint(data)
    return getattr(self, data.keys()[0])(data[data.keys()[0]])

  def queue(self, users):
    return 'Queue has %s users: %s' % (len(users), ', '.join(users))

  def game(self, game):
    if game['state'] == 'accepting':
      return ('Offering game %s. Use !accept to confirm or !decline to leave the queue'
          '\n  Waiting on: %s'
          '\n  Accepted by: %s'
          % (game['id'], ', '.join(game['waiting']), ', '.join(game['accepted'])))
    elif game['state'] == 'active':
      return ('Game %s is ready. Join lobby with password %s'
          '\n  Radiant: %s\n  Dire: %s' % (game['password'], ', '.join(game['radiant']), ', '.join(game['dire'])))
  def ratings(self, ratings):
    return ('Rating changes from game %s: %s victory. Game quality: %0.2f'
        '\n  Radiant:' + (''.join(['\n    %s: mu %0.2f %+0.2f | sigma %0.2f %+0.2f' % 
          (u['username'], u['mu'], u['delta_mu'], u['sigma'], u['delta_sigma']) for u in ratings['radiant']])) +
        '\n  Dire:' +    (''.join(['\n    %s: mu %0.2f %+0.2f | sigma %0.2f %+0.2f' % 
          (u['username'], u['mu'], u['delta_mu'], u['sigma'], u['delta_sigma']) for u in ratings['dire']])))

bot = Bot(name)
bot.connect('irc.synirc.net', channel=channel)
bot.start()
