defmodule OpsDeskWeb.ErrorHTMLTest do
  use OpsDeskWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template, only: [render_to_string: 4]

  test "renders 404.html" do
    html =
      render_to_string(OpsDeskWeb.ErrorHTML, "404", "html", %{flash: %{}, current_scope: nil})

    assert html =~ "Page not found"
    assert html =~ "Back home"
  end

  test "renders 500.html" do
    html =
      render_to_string(OpsDeskWeb.ErrorHTML, "500", "html", %{flash: %{}, current_scope: nil})

    assert html =~ "Something went wrong"
    assert html =~ "Back home"
  end
end
