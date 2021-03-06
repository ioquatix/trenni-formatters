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

require 'trenni/builder'
require 'trenni/template'

require_relative 'form_formatter'

module Trenni
	module Formatters
		module HTML
			module LabelForm
				include FormFormatter
				
				# An input field (single line text).
				def input(**options)
					options = @options.merge(**options)
					
					Builder.fragment do |builder|
						builder.inline(:label) do
							builder.inline(:span) do
								builder.text title_for(**options)
								
								if details = details_for(**options)
									builder.inline(:small) {builder.text details}
								end
							end
							
							builder.inline :input, input_attributes_for(**options)
						end
					end
				end
				
				# An output field for the result of a computation.
				def output(**options)
					options = @options.merge(**options)
					
					builder.inline(:label) do
						builder.inline(:span) do
							builder.text title_for(**options)
							
							if details = details_for(**options)
								builder.inline(:small) {builder.text details}
							end
						end
						
						builder.inline :output, output_attributes_for(**options) do
							builder.text value_for(**options)
						end
					end
				end
				
				# A textarea field (multi-line text).
				def textarea(**options)
					options = @options.merge(**options)
					
					Builder.fragment do |builder|
						builder.inline(:label) do
							builder.inline(:span) do
								builder.text title_for(**options)
								
								if details = details_for(**options)
									builder.inline(:small) {builder.text details}
								end
							end
							
							builder.tag :textarea, textarea_attributes_for(**options) do
								builder.text value_for(**options)
							end
						end
					end
				end
				
				# A checkbox field.
				def checkbox(**options)
					options = @options.merge(**options)
					
					Builder.fragment do |builder|
						builder.inline(:label) do
							builder.inline :input, :type => :hidden, :name => name_for(**options), :value => 'false'
							
							builder.inline(:span) do
								if details = details_for(**options)
									builder.inline(:small) {builder.text details}
								end
							end
							
							builder.tag :input, checkbox_attributes_for(**options)
							
							# We would like a little bit of whitespace between the checkbox and the title:
							builder.text " " + title_for(**options)
						end
					end
				end
				
				# A submission button
				def submit(**options)
					options = @options.merge(**options)
					options[:title] ||= submit_title_for(**options)
					
					Builder.fragment do |builder|
						builder.inline :input, submit_attributes_for(**options)
					end
				end
				
				def element(klass, **options, &block)
					options = @options.merge(**options)
					buffer = Trenni::Template.buffer(block.binding)
					
					Builder.fragment(buffer) do |builder|
						builder.inline(:label) do
							builder.inline(:span) do
								builder.text title_for(**options)
								
								if details = details_for(**options)
									builder.inline(:small) {builder.text details}
								end
							end
							
							klass.call(self, builder, **options, &block)
						end
					end
				end
			end
		end
	end
end
