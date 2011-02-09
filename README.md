It's a pain to always develop with I18n - it makes it hard to search for things.

There's no reason you shouldn't be able to develop with your native language inline, and then extract the text out of your markup and into a YML file live, replacing the native segments with ERB translation calls.

__Under Development - not quite ready for use__

---

## Usage

Template:

    <t id="name_label">Information:</t>
    <t their_name="'john'">my name is %{their_name}</t>

Locale files:

    es:
      name_label: "Información:"
      my_name_is: "My name is %{their_name}"

---

## Pluralization?

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
