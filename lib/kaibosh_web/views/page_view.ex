defmodule KaiboshWeb.PageView do
  use KaiboshWeb, :view
  @env Mix.env()

  if @env == :dev do
    def dev_env?, do: true
  else
    def dev_env?, do: false
  end
end
