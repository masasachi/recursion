defmodule UserStory do
  defstruct id: "", parent_id: nil
end

defmodule Recursion do
  @doc ~S"""
  iex> [%UserStory{id: "2", parent_id: "1"}, %UserStory{id: "4", parent_id: "3"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "1", parent_id: nil}] |> Recursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]
  iex> [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}] |> Recursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]
  iex> [%UserStory{id: "4", parent_id: "3"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "1", parent_id: nil}] |> Recursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]
  """
  def ordered_tree(epics), do: recursive_epics(epics, nil)

  def recursive_epics(epics, _) when epics == [], do: []

  def recursive_epics(epics, id) do
    {[root | _], child} =
      epics
      |> Enum.split_with(&(&1.parent_id == id))

    [root] ++ recursive_epics(child, root.id)
  end
end

defmodule TailRecursion do
  @doc ~S"""
  iex> [%UserStory{id: "2", parent_id: "1"}, %UserStory{id: "4", parent_id: "3"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "1", parent_id: nil}] |> TailRecursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]

  iex> [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}] |> TailRecursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]

  iex> [%UserStory{id: "4", parent_id: "3"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "1", parent_id: nil}] |> TailRecursion.ordered_tree()
  [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}, %UserStory{id: "3", parent_id: "2"}, %UserStory{id: "4", parent_id: "3"}]
  """
  def ordered_tree(epics), do: recursive_epics(epics, nil, [])

  def recursive_epics(epics, _, acc) when epics == [], do: acc ++ []

  def recursive_epics(epics, id, acc) do
    {[root | _], child} =
      epics
      |> Enum.split_with(&(&1.parent_id == id))

    recursive_epics(child, root.id, acc ++ [root])
  end
end

defmodule CreateUserStory do

  @doc ~S"""
  iex> [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}] |> CreateUserStory.insert_middle("1")
  "2"

  iex> [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}] |> CreateUserStory.insert_middle("2")
  nil

  iex> [] |> CreateUserStory.insert_middle(nil)
  nil

  iex> [%UserStory{id: "1", parent_id: nil}, %UserStory{id: "2", parent_id: "1"}] |> CreateUserStory.insert_middle(nil)
  "1"
  """
  def insert_middle(items, insert_parent_id) do
    update_story =
      items
      |> Enum.filter(&(&1.parent_id == insert_parent_id))
      |> List.first()

    case update_story do
      nil -> nil

      _ -> Map.get(update_story, :id)
    end
  end
end
