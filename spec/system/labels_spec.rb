require 'rails_helper'
RSpec.describe "Fonctions de gestion des étiquettes", type: :system do
  describe "Fonction d'enregistrement" do

    let!(:user) { FactoryBot.create(:user) }
    context "Lorsque les étiquettes sont enregistrées" do

      before do
        visit new_session_path
        fill_in "session_email", with: user.email
        fill_in "session_password", with: "123456"
        click_button "Log in"
      end
      it "Les étiquettes enregistrées sont affichées." do
        visit new_label_path
        fill_in "label_name", with: "étiquette"
        click_button "enregistrer"
        expect(page).to have_content "Label enregistré"
        expect(page).to have_content "Page de liste d'étiquettes"
      end
    end
  end

  describe "Fonction d'affichage de liste" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:label_1) { FactoryBot.create(:label, name: "label1", user: user) }
    let!(:label_2) { FactoryBot.create(:label, name: "label2", user: user) }

    before do
      visit new_session_path
      fill_in "session_email", with: user.email
      fill_in "session_password", with: "123456"
      click_button "Log in"
    end

    context "Lors de la transition vers l'écran de liste" do
      it "Une liste des étiquettes enregistrées s'affiche." do
        visit labels_path
        expect(page).to have_content "label1"
        expect(page).to have_content "label2"
      end
    end
  end
end