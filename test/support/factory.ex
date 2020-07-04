defmodule Kaibosh.Factory do
  use ExMachina.Ecto, repo: Kaibosh.Repo
  alias Kaibosh.Organisations

  def base_factory do
    %Organisations.Base{
      name: sequence(:name, &"Test Base #{&1}"),
      organisation: build(:organisation)
    }
  end

  def organisation_factory do
    %Organisations.Organisation{
      name: sequence(:name, &"Test Org #{&1}")
    }
  end

  def staff_factory do
    %Organisations.Staff{
      first_name: "John",
      last_name: "Smith",
      base: build(:base)
    }
  end
end
