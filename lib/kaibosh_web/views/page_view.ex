defmodule KaiboshWeb.PageView do
  use KaiboshWeb, :view
  @env Mix.env()
  def dev_env?, do: @env == :dev
end
