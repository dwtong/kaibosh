defmodule Kaibosh.Factory do
  use ExMachina.Ecto, repo: Kaibosh.Repo
  alias Kaibosh.Organisations
  alias Kaibosh.Recipients
  alias Kaibosh.Sessions

  def base_factory do
    %Organisations.Base{
      name: sequence(:name, &"Test Base #{&1}"),
      organisation: build(:organisation)
    }
  end

  def contact_factory do
    %Recipients.Contact{
      recipient: build(:recipient),
      name: "John Smith"
    }
  end

  def organisation_factory do
    %Organisations.Organisation{
      name: sequence(:name, &"Test Org #{&1}")
    }
  end

  def recipient_factory do
    %Recipients.Recipient{
      name: sequence(:name, &"Test Recipient #{&1}"),
      base: build(:base)
    }
  end

  def session_factory do
    %Sessions.Session{
      time_in_seconds: 10_000,
      day: "monday",
      base: build(:base)
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
