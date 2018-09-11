defmodule Pluggy.Template do
	def render(file, data\\ [], layout \\ true)
  def render(file, data , layout) do
  	case layout do
    	true -> 
				EEx.eval_file("templates/layout.eex", template: EEx.eval_file("templates/#{file}.eex", data))
    	false -> 
    		EEx.eval_file("templates/#{file}.eex", data)
    end
  end
end
