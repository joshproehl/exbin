defmodule ExBinWeb.PageController do
  use ExBinWeb, :controller
  alias ExBin.{Snippet, Repo}


  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, _args = %{"snippet" => args}) do
    IO.inspect args
    changeset = Snippet.changeset(%Snippet{}, args)


    {:ok, snippet} = Repo.insert(changeset)

    redirect conn, to: "/#{snippet.id}"
    # render conn, "show.html", snippet: snippet
  end

  def show(conn, %{"id" => id}) do
    snippet = Repo.get(Snippet, id)
    render conn, "show.html", snippet: snippet
    end
end
