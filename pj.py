import json, sys, pprint
for line in sys.stdin:
  try:
    pprint.pprint(json.loads(line))
  except Exception:
    print line.strip()

