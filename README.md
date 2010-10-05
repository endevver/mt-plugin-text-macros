This plugin provides a framework for developers to create really simple text macros 
that can processed inside of text. What is a macro? Well imagine you need a way of
embedding within an entry some dynamic text, like the URL to page elsewhere on the 
site. Suppose you don't know the actual URL or the URL may actually change, but 
you do know the page's ID. So using this plugin you can embed the following text
inside of an entry:

   [% PageURL id="32" %]

# Enabling Macros

To turn on the text macro capabilities you need to add the following attribute to
any template tag: `text_macros="1"`. 

You can easily encapsulate any text output by a template and enable macros for 
large blocks like so:

   <mt:section text_macros="1">
        [% PageURL id="3" %]
   </mt:section>

# Macro Syntax

Macros are bounded by an opening `[%` and a closing `%]`. They cannot encapsulate
text. They are only tokens that will be substituted by a text value later.

Arguments not recognized by a macro will be ignored.

## Examples

The following are all acceptable syntaxes for the same tag.

* `[% PageURL id="3" %]`
* `[%PageURL id="3"%]`
* `[%pageurl id="3" ignore_me="foo"%]`

**Known Issue**

Macros that do not have a handler defined for them will have a blank string
substituted in their place.

# Handlers

Handlers for new macros are defined in a plugin's config.yaml under the `text_macros` 
key. Each macro specifies a handler for processing input. Each handler takes as input
a single argument in the form of a hash containing the arguments passed into the
tag. 

## Example

In your plugin define the following in the registry:

    id: MyPlugin
    name: 'My Plugin'
    text_macros: 
      PageURL: $MyPlugin::MyPlugin::macro_page_url

Then create the following library file `plugins/MyPlugin/lib/MyPlugin.pm` and in
it create the following subroutine:

    sub macro_page_url {
      my ($args) = @_;
      my $page;
      if ($args->{'id'}) {
          $page = MT->model('page')->load( $args->{'id'} );
      } elsif ($args->{'basename'}) {
          $page = MT->model('page')->load({ basename => $args->{'basename'} });
      }
      return $page->permalink;
    }

# Installation

To install this plugin follow the instructions found here:

http://tinyurl.com/easy-plugin-install

# License

This plugin is licensed under the same terms as Perl itself.