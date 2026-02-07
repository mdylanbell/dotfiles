import sys

try:
    import tomllib
except Exception:
    sys.exit(5)

if len(sys.argv) < 4:
    sys.exit(2)

mode = sys.argv[1]
path = sys.argv[2]
keys = sys.argv[3:]

try:
    with open(path, "rb") as f:
        data = tomllib.load(f)
except Exception:
    sys.exit(3)

cur = data
for key in keys:
    if not isinstance(cur, dict):
        cur = None
        break
    cur = cur.get(key)

if mode == "list":
    if cur is None:
        sys.exit(0)
    if not isinstance(cur, list):
        sys.exit(4)
    for item in cur:
        if isinstance(item, str) and item:
            print(item)
    sys.exit(0)

if mode == "bool":
    if cur is None:
        sys.exit(0)
    if not isinstance(cur, bool):
        sys.exit(4)
    print("true" if cur else "false")
    sys.exit(0)

if mode == "string":
    if cur is None:
        sys.exit(0)
    if not isinstance(cur, str):
        sys.exit(4)
    if cur:
        print(cur)
    sys.exit(0)

if mode == "string_or_list":
    if cur is None:
        sys.exit(0)
    if isinstance(cur, str):
        if cur:
            print(cur)
        sys.exit(0)
    if isinstance(cur, list):
        items = [item for item in cur if isinstance(item, str) and item]
        if items:
            print("\n".join(items))
        sys.exit(0)
    sys.exit(4)

sys.exit(0)
