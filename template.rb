#!/usr/bin/env ruby
# Copyright (c) 2013 Robert Qualls

# Design pattern covered: Template
#
# An important tenet of creating adaptable software is separating the things
# that change from the things that stay the same
# 
# Let's look at what can happen when this ISN'T done
#
# You have a document class that outputs a single format, so you code like so:

class BadDocument
  def initialize
    @title = "Document Title"
    @body = ['This is line 1','This is line 2']
  end 

  def render
    puts('<document>')
    puts('<title>#{@title}</title>')
    puts('<text>#{@body}</text>')
    puts('</document')
  end
end

# This is all well and good so far, but what if you want to be able to output
# multiple formats?
#
# Let's see what happens when you try a simple switch

class WorseDocument
  def initialize
    @title = "Document Title"
    @body = ['This is line 1','This is line 2']
  end

  def render(format)
    case format
    when :xml
      # xml output title
      # xml output each line of text
    when :html
      # html output title
      # html output each line of text
    when :plain_text
      # plain text output title
      # plain text output each line of text
    end
  end 
end

# If many additional formats are requested, it could cause WorseDocument#render
# to grow to a size where it cannot be maintained effectively
#
# We can solve this problem by placing all of the code that will always get
# called into its own class

class BaseDocument
  def initialize
    @title = "Document Title"
    @body = ['This is line 1', 'This is line2']
  end

  def render(format)
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @body.each |line| do
      output_line(line)
    end
  end

  def output_start
  end

  def output_end
  end

  # . . . etc

end

# Now that we have a document class that all documents can be based on, we can
# define a class for each format type

class XMLDocument < BaseDocument
  def output_start
    puts('<document>')
  end

  def output_head
    puts('<title>#{@title}</title>')
  end

  def output_body_start
    puts('<text>')
  end

  def output_body_end
    puts('</text>')
  end

  def output_end
    puts('</document>')
  end
end

class HTMLDocument < BaseDocument
  # similar to XMLDocument
end

class PlainDocument < BaseDocument
  def output_head
    puts @title
  end
end

# This is the Template Design Pattern - defining common features in a base
# class and placing variable features in subclasses
#
# One of the important things about this pattern is that subclasses don't
# necessarily have to implement every method - in this case, the subclasses
# do not override output_body because it already works for them
