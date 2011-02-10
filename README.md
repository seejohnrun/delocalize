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

---

## License

(The MIT License)

Copyright © 2010 John Crepezzi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
