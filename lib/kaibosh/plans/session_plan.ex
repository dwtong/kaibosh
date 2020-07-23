defmodule Kaibosh.Plans.SessionPlan do
  @moduledoc """
  Session plan that includes grouped recipents.
  Recipients are grouped by category, and include their allocations.
  """
  defstruct [:session, :recipients_by_category]
end
