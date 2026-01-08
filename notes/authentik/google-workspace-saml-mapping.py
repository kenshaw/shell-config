attributes = root.find(".//{urn:oasis:names:tc:SAML:2.0:assertion}AttributeStatement")

def get_attr(name):
    for attr in attributes.findall("{urn:oasis:names:tc:SAML:2.0:assertion}Attribute"):
        if attr.attrib.get("Name") == name:
            return attr.find("{urn:oasis:names:tc:SAML:2.0:assertion}AttributeValue").text
    raise Exception(f"unable to find '{name}'")

# determine email and username, validate
email = get_attr("email")
uname = email.split('@')[0]
if len(uname) == 0:
  raise Exception(f"invalid email {email}")
if "admin" in uname.lower():
  raise Exception(f"invalid user {uname}")

# get first, last, name, validate
fname = get_attr("firstname")
lname = get_attr("lastname")
name = f"{fname} {lname}".strip()
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
