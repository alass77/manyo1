require 'rails_helper'

RSpec.describe 'fonctions de gestion des utilisateurs', type: :system do
  describe "Fonction d'enregistrement" do
    context "Si un utilisateur est enregistré" do
      it "Transition vers l'écran de la liste des tâches" do
        visit new_user_path
        fill_in "user_name", with: "dada"
        fill_in "user_email", with: "dada@gmail.com"
        fill_in "user_password", with: "123456"
        fill_in "user_password_confirmation", with: "123456"
        click_button "Create my account"
        expect(page).to have_content("Page de la liste des tâches")
      end
    end
    context "Si vous êtes passé à l'écran Liste des tâches sans vous connecter" do
      it "Vous êtes redirigé vers lécran de connexion et le message Veuillez vous connecter saffiche." do
        visit tasks_path
        expect(page).to have_content("Veuillez vous connecter")
        expect(page).to have_content("Login Page")
      end
    end
  end

  describe 'Fonction de connexion' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    context "Lorsque vous êtes connecté en tant qu'utilisateur enregistré." do
        before do
            visit new_session_path
            fill_in "session_email", with: user.email
            fill_in "session_password", with: "123456"
            click_button "Log in"
        end
      it "Vous serez redirigé vers l'écran de la liste des tâches et le message Vous êtes connecté s'affichera." do
        expect(page).to have_content("J'ai réussi à me connecter")
        expect(page).to have_content("Page de la liste des tâches")
      end
      it "Accès à votre propre écran de détail." do
        click_link "Account"
        expect(page).to have_content "Account details page"
        expect(page).to have_content user.name
      end
      it "En accédant à l'écran de détails d'une autre personne, vous accédez à l'écran de la liste des tâches." do
        visit user_path(second_user)
        expect(page).to have_content("Vous seul pouvez accéder")
        expect(page).to have_content("Page de la liste des tâches")
      end
      it "Lors de la déconnexion, l'utilisateur revient à l'écran de connexion et le message Vous vous êtes déconnecté s'affiche." do
        click_link "Logout"
        expect(page).to have_content("Vous avez été déconnecté")
        expect(page).to have_content("Login Page")
      end
    end
  end

  describe "Fonctionnalité de l'administrateur" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    context "Lorsque l'administrateur se connecte." do
        before do
            visit new_session_path
            fill_in "session_email", with: second_user.email
            fill_in "session_password", with: "123456"
            click_button "Log in"
        end
    
      it "Accès à l'écran de la liste des utilisateurs." do
        click_link "Liste des utilisateurs"
        expect(page).to have_content("Liste des utilisateurs")
      end
      it 'Peut enregistrer les administrateurs.' do
        visit new_admin_user_path
        fill_in "user_name", with: "user"
        fill_in "user_email", with: "user@user.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "Créer l'administrateur"
        expect(page).to have_content("J'ai réussi à créer un compte")
        expect(page).to have_content("Liste des utilisateurs")
      end
      it "Accès à l'écran des détails de l'utilisateur." do
        visit admin_user_path(user)
        expect(page).to have_content("Page de détails de l'utilisateur")
      end
      it "Vous pouvez modifier les utilisateurs autres que vous-même à partir de l'écran de modification des utilisateurs." do
        visit edit_admin_user_path(user)
        expect(page).to have_content("Edit User")
      end
      it "Les utilisateurs peuvent être supprimés." do
        visit admin_users_path
        find("a[data-destroy_user='#{user.id}']").click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "L'utilisateur a été supprimé avec succès."
        expect(page).to have_content "Liste des utilisateurs"
      end
    end
    context "Lorsqu'un utilisateur général accède à l'écran de la liste des utilisateurs" do
        before do
            visit new_session_path
            fill_in "session_email", with: user.email
            fill_in "session_password", with: "123456"
            click_button "Log in"
        end
      it "Passage à l'écran de la liste des tâches, avec un message d'erreur Seuls les administrateurs peuvent y accéder." do
        visit admin_users_path
        expect(page).to have_content 'Page de la liste des tâches'
        expect(page).to have_content "Seuls les administrateurs peuvent accéder"
      end
    end
  end
end