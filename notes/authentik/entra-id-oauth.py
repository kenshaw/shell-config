return {
    "uid": info.get("mail"),
    "name": info.get("displayName"),
    "username": info.get("mail").split('@')[0],
    "email": info.get("mail"),
    "attributes": {
      "firstname": info.get("givenName"),
      "lastname": info.get("surname")
    }
}
