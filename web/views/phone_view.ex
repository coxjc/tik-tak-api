defmodule Api.PhoneView do
  use Api.Web, :view

  def render("index.json", %{phone: phone}) do
    %{data: render_many(phone, Api.PhoneView, "phone.json")}
  end

  def render("show.json", %{phone: phone}) do
    %{data: render_one(phone, Api.PhoneView, "phone.json")}
  end

  def render("phone.json", %{phone: phone}) do
    %{id: phone.id,
      number: phone.number,
      code: phone.code,
      code_sent: phone.code_sent,
      verified: phone.verified}
  end
end
