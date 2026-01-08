current_groups = [g.name for g in request.user.ak_groups.all()]

if "foobar-user" not in current_groups:
    current_groups.append("foobar-user")

return {
    "groups": current_groups
}
