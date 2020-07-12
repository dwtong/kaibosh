defmodule Kaibosh.Factory do
  use ExMachina.Ecto, repo: Kaibosh.Repo
  alias Kaibosh.Accounts
  alias Kaibosh.Organisations
  alias Kaibosh.Recipients
  alias Kaibosh.RecipientSessions
  alias Kaibosh.Sessions

  def allocation_factory do
    %RecipientSessions.Allocation{
      recipient_session: build(:recipient_session),
      category: build(:category)
    }
  end

  def category_factory do
    %Organisations.Category{
      name: "apples",
      unit: "boxes",
      base: build(:base)
    }
  end

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

  def hold_factory do
    %RecipientSessions.Hold{
      recipient_session: build(:recipient_session),
      starts_at: ~U[2010-04-17 14:00:00Z]
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
      base: build(:base),
      signed_terms_at: ~U[2020-01-01T00:00:00Z],
      met_kaibosh_at: ~U[2020-01-01T00:00:00Z],
      started_at: ~U[2020-01-01T00:00:00Z]
    }
  end

  def recipient_session_factory do
    %RecipientSessions.RecipientSession{
      session: build(:session),
      recipient: build(:recipient)
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

  def user_factory do
    %Accounts.User{
      email: sequence(:email, &"email#{&1}@test.com"),
      password_hash: "xxxxxx"
    }
  end

  def user_session_factory do
    %Accounts.UserSession{
      token: Ecto.UUID.generate(),
      user: build(:user)
    }
  end
end
