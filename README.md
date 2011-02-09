It's a pain to always develop with I18n - it makes it hard to search for things.

__Under Development - not quite ready for use__

Template:

    <%- name = 'john' %>
    <t id="name_label">Information:</t>
    <t their_name="name">my name is %{their_name}</t>

Locale files:

    es:
      name_label: "Información:"
      my_name_is: "My name is %{their_name}"

Result:

    Información:
    my name is john
