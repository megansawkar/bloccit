require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context "unauthenticated user" do
    it "PUT update returns http unauthenticated" do
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body}
      expect(response).to have_http_status(401)
    end

    it "POST create returns http unauthenticated" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body}
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    it "PUT update returns http forbidden" do
      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body}
      expect(response).to have_http_status(401)
    end

    it "POST create returns http forbidden" do
      post :create, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body}
      expect(response).to have_http_status(401)
    end

    it "DELETE destroy returns http forbidden" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_topic = build(:topic)
      @new_post = build(:post, topic: @new_topic, user: my_user)
    end

    describe "PUT update" do
      before { put :update, topic_id: my_topic.id, id: my_post.id, post: {title: my_post.title, body: my_post.body} }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "updates a post with the correct attributes" do
        updated_post = Post.find(my_topic.id, my_post.id)
        expect(response.body).to eq(updated_post.to_json)
      end
    end

    describe "POST create" do
      before { post :create, post: {title: @new_post.title, body: @new_post.body} }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a post wtih the correct attributes" do
        hashed_json = JSON.parse(response.body)
        expect(hashed_json["title"]).to eq(@new_post.title)
        expect(hashed_json["description"]).to eq(@new_post.description)
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, topic_id: my_topic.id, id: my_post.id }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "returns the correct json success message" do
        expect(response.body).to eq({ message: "Post destroyed", status: 200 }.to_json)
      end

      it "deletes my_topic" do
        expect{ Post.find(my_topic.id, my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
