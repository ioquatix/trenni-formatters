# frozen_string_literal: true

# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'trenni/strings'
require 'mapping/model'
require 'mapping/descendants'

module Trenni
	module Formatters
		class Formatter < Mapping::Model
			def self.for(object, **options)
				self.new(object: object, **options)
			end
			
			def initialize(**options)
				@options = options
				
				@object = nil
			end
			
			# The target object of the form.
			def object
				@object ||= @options[:object]
			end
			
			def nested_name(**options)
				options[:nested_name] || @options[:nested_name]
			end
			
			# The name of the field, used for the name attribute of an input.
			def name_for(**options)
				name = options[:name] || options[:field]
				
				if suffix = options[:suffix]
					name = "#{name}#{suffix}"
				end
				
				if nested_name = self.nested_name(**options)
					"#{nested_name}[#{name}]"
				else
					name
				end
			end
			
			def nested_name_for(**options)
				name_for(**options)
			end
			
			def nested(name, key = name, klass: self.class)
				options = @options.dup
				target = self.object.send(name)
				
				options[:object] = target
				options[:nested_name] = nested_name_for(name: key)
				
				formatter = klass.new(**options)
				
				return formatter unless block_given?
				
				yield formatter
			end
			
			attr :options
			
			def format_unspecified(object, **options)
				object.to_s
			end

			def format(object, **options)
				method_name = self.method_for_mapping(object)
				
				if self.respond_to?(method_name)
					self.send(method_name, object, **options)
				else
					format_unspecified(object, **options)
				end
			end

			alias text format

			def [] key
				@options[key]
			end
			
			map(String) do |object, **options|
				object
			end
			
			map(NilClass) do |object, **options|
				options[:blank] || @options[:blank] || ""
			end
			
			map(TrueClass, FalseClass, *Mapping.lookup_descendants(Numeric)) do |object, **options|
				object.to_s
			end
		end
	end
end
