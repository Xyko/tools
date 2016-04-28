#!/usr/bin/env ruby
# encoding : utf-8
require 'rubygems'
require 'colorize'
require 'awesome_print'


def somatorio n 

	aux = n
	if n > 0
		aux += somatorio n - 1
	end
	return aux

end



ap somatorio 5 
