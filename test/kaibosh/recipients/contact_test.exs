defmodule Kaibosh.Recipients.ContactTest do
  use Kaibosh.DataCase
  alias Kaibosh.Recipients.Contact

  @valid_attrs %{name: "Jim Henry"}

  test "cannot have invalid email" do
    changeset = Contact.changeset(%Contact{}, Map.put(@valid_attrs, :email, "blah"))
    assert %{email: ["has invalid format"]} = errors_on(changeset)
  end

  test "can have valid email" do
    changeset = Contact.changeset(%Contact{}, Map.put(@valid_attrs, :email, "blah@blah.com"))
    assert %{} = errors_on(changeset)
  end
end
