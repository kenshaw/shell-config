# determine email and username, validate
email = info.get("mail")
uname = email.split('@')[0]
if len(uname) == 0:
  raise Exception(f"invalid email {email}")
if "admin" in uname.lower():
  raise Exception(f"invalid user {uname}")

# get first, last, name, validate
name = info.get("displayName").strip()
fname = info.get("givenName").strip()
lname = info.get("surname").strip()

if len(name) < 3:
  raise Exception(f"invalid name '{name}'")

return {
    "uid": email,
    "name": name,
    "username": uname,
    "email": email,
    "attributes": {
      "firstname": fname,
      "lastname": lname
    }
}
