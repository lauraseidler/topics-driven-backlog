class SprintSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :start_date, :end_date, :course_id, :topic_ids
end
