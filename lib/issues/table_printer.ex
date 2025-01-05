defmodule Issues.TablePrinter do

@moduledoc """
This module helps in printing the issues that we get from the github api
in a tabular format
"""

@header_delimeter "-+-"
@record_delimiter " | "

	@doc """
	Prints the output in a tabular format
	Like this:
	 #  | created_at           | title
 	----+----------------------+-----------------------------------------
 	889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
 	892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
 	893 | 2013-03-21T06:23:00Z | mix test time reports
 	898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors
	"""
	def print(list) do
		max_id_length = max_length(list,"id")
		max_created_at_length = max_length(list,"created_at")
		max_title_length = max_length(list,"title")
		print_table_header(max_id_length,max_created_at_length,max_title_length)
		print_records(list,max_id_length)
	end

	defp max_length(list,field) do
		list
			|> Stream.map(fn c -> get_length(c[field]) end)
    		|> Enum.max()
  	end

  	defp get_length(field) when is_number(field) do 
  		field 
  			|> Integer.digits() 
  			|> length()
  	end

  	defp get_length(field) when is_binary(field), do: String.length(field)

  	defp print_table_header(max_id_len,max_ca_len,max_title_len) do
  		IO.puts create_result_header(max_id_len,max_ca_len)
  		IO.puts String.duplicate("-",max_id_len)
  			<>@header_delimeter
  			<>String.duplicate("-",max_ca_len)
  			<>@header_delimeter
  			<>String.duplicate("-",max_title_len) 
  	end

  	defp create_result_header(max_id_len,max_ca_len) do
  		add_spaces("#",max_id_len)
  				<> @record_delimiter
  				<> add_spaces("created_at",max_ca_len)
  				<> @record_delimiter
  				<> "title"
  	end


  	defp print_records(list, max_id_len) do
  		Enum.each(list,fn rec -> print_record(rec,max_id_len) end)
  	end

  	defp print_record(record,max_id_len) do
  		IO.puts create_record(record,max_id_len)
  	end

  	defp create_record(record,max_id_len) do
  		add_spaces(Integer.to_string(record["id"]),max_id_len) 
  				<> @record_delimiter
  				<> record["created_at"]
  				<> @record_delimiter
  				<> record["title"]
  	end

  	defp add_spaces(word,top_length) do
  		padding = top_length-String.length(word)
  		do_add_spaces(word,padding)
  	end

  	defp do_add_spaces(word,0), do: word

  	defp do_add_spaces(word,padding) when padding < 0, do: word

  	defp do_add_spaces(word,padding) do
  		word <> String.duplicate(" ",padding)
  	end

end
