# Gem Init

This is the code I use to set up a new Ruby Gem.

Github and Rubygems.org make it ridiculously easy to share your code using Gems.
Sometimes I have something small and useful I'd like to make a gem, but I'm too
lazy to set up all the packaging boilerplate, and I prefer not to introduce
tools like Jewler or Hoe just to manage a gemspec, which is a trivially easy
file to maintain. Setting up a new gem is boring, so I spent a couple hours
putting this together as a reusable gem. If you like it, please feel free to use
it for whatever purpose you choose. Bug fixes, and patches are of course
welcome.

## Using it:

    gem install gem_init
    gem_init hello_world

A brief summary of some of the quirkiness is below:

## Your name, email and Github user name

These are read from your `~/.gitconfig` if available and used to populate some
basic info in the gemspec.

## MIT-LICENSE

This is the license I almost always use for my open source work, so it's the
default.

## Gemfile.default

I prefer not to check my Gemfiles into git, because I usually tweak it a lot
when testing against lots of different versions of my dependencies. So I usually
just add a Gemfile.default with something that should work, and copy that to
Gemfile before working.

The only thing added by default to the Gemfile is your generated library itself,
which is an easy way to avoid messing around with the `LOAD_PATH` in your test
setup.

I am assuming Bundler version 1.0.x, which you can currently get by doing

    gem install bundler --pre

But by the time you're reading this, it may already be the current stable
release.

## test_helper.rb

This just adds a `test` method to the `Module` class, so you can write
declarative tests:

    test "something should do something" do
      assert_equal foo, bar
    end

Having this as a class method in `Module` means you can write your unit tests in
either modules or classes. Being able to group related tests in modules and give
them declarative names for me is "good enough" to make up for Test::Unit's
ugliness, and I like the fact that it's just plain old Ruby.

I tend to do this rather than use a bigger test framework, because it introduces
less dependencies and makes it very easy for people to just check out my gem and
run my tests with the minimum of effort.

## *.gemspec

Rather than manually specifying everything, I just pull the files I want to add
to the gem out of the list of files added to Git. This works fine most of the
time, with the only caveat being that you need to have your stuff in Git before
building your gem, or using the directory as a gem via Bundler.

## Rakefile

This adds a soft dependency on [Yard](http://yardoc.org/); the task is added only if you
have it installed.

Otherwise, by default a `gem` method is added to package your gem, and a `clean`
method is there to tidy up your repository.

## .gitignore

By default, I ignore Gemfile, Gemfile.lock, pkg and doc directories. Obviously
you can and should change this to whatever makes sense for you.

## README.md

I like to use Markdown for my README files, as it plays nicely with Yard.
