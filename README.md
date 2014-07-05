This plugin provides a framework for developers to create really simple text macros 
that can processed inside of text. What is a macro? Well imagine you need a way of
embedding within an entry some dynamic text, like the URL to page elsewhere on the 
site. Suppose you don't know the actual URL or the URL may actually change, but 
you do know the page's ID. So using this plugin you can embed the following text
inside of an entry:

   [% PageURL id="32" %]

# Installation

To install this plugin follow the instructions found here:

http://tinyurl.com/easy-plugin-install

# Supported Macros

* `PageURL` - takes a single argument `id` which identifies the page for which
  to generate a URL for. 

Need another macro, but don't know how to build one yourself? At Endevver, we'll 
create one for you. And if it is simple, which it probably will be, we'll do it
for free. We're that nice. Yes we are. Visit our [help center](http://help.endevver.com)
to submit your request. 

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

# Developer Guide

## Creating New Macros - Writing a Handler

Handlers for new macros are defined in a plugin's config.yaml under the `text_macros` 
key. Each macro specifies a handler for processing input. Each handler takes as input the current template context and an argument in the form of a hash containing the arguments passed into the
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
      my ($ctx, $args) = @_;
      my $page;
      if ($args->{'id'}) {
          $page = MT->model('page')->load( $args->{'id'} );
      } elsif ($args->{'basename'}) {
          $page = MT->model('page')->load({ basename => $args->{'basename'} });
      }
      return $page ? $page->permalink : '';
    }

# Frequently Asked Questions

**Does Text Macros work with any MT template tag and if so how is this different from mteval?**

Text Macros is a distinct "language" from the more powerful templating language that 
powers Movable Type and Melody. The reason we developed these macros was in order to 
create a much simpler and more constrained way of injecting dynamically generated content
into an entry. We could have used the MTEval plugin, but we ultimately felt that the 
MT templating language is too verbose, and for simple tasks, like embedding a URL to a page
requires too much knowledge. 

# Help, Bugs and Feature Requests ##

If you are having problems installing or using the plugin, or if you would like to request
us to implement a new macro to add to this pack, please check out our general knowledge 
base and help ticket system at [help.endevver.com](http://help.endevver.com).

# About Endevver 

We design and develop web sites, products and services with a focus on 
simplicity, sound design, ease of use and community. We specialize in 
Movable Type and offer numerous services and packages to help customers 
make the most of this powerful publishing platform.

http://www.endevver.com/

# Copyright 

Copyright 2010, Endevver, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.