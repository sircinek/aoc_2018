defmodule CList do
  def new do
    {[], []}
  end

  def list_to_clist(list) when is_list(list) do
    {[], list}
  end

  def clist_to_list({pre, post}) do
    Enum.reverse(pre) ++ post
  end

  def prev({[], []}), do: {:error, :empty}
  def prev({[], post}) do
    [f|pre] = Enum.reverse(post)
    {pre, [f]}
  end

  def prev({[h|t], post}) do
    {t, [h|post]}
  end

  def next({[], []}), do: {:error, :empty}
  def next({pre, [h|[]]}) do
    post = Enum.reverse([h|pre])
    {[], post}
  end

  def next({pre, [h|t]}) do
    {[h|pre], t}
  end

  def insert({pre, post}, value) do
    {pre, [value|post]}
  end

  def pop({pre, [value|post]}) do
    {value, {pre, post}}
  end

  def current({_pre, [current|_]}) do
    current
  end


end
