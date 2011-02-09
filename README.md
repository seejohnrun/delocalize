It's a pain to always develop with I18n - it makes it hard to search for things.

__Under Development - not quite ready for use__

---

## Usage

Template:

    <%- name = 'john' %>
    <t id="name_label">Information:</t>
    <t their_name="name">my name is %{their_name}</t>

Locale files:

    es:
      name_label: "Información:"
      my_name_is: "My name is %{their_name}"

---

## Pluralization

Template:

    <t id="repo_count" count="repo_count" yml="true"> # will change soon
      one: You have one repository
      other: You have %{count} repositories
    </t>

Locale files:

    de:
      repo_count:
        one: sie haben ein repository
        other: sie haben %{count} repositories
