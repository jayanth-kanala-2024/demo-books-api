# app/models/concerns/soft_delete.rb
module SoftDelete
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted: false) }
    scope :for_admin, -> { unscoped }
  end

  def soft_delete
    transaction do
      update_columns(deleted: true, deleted_at: Time.current)
      soft_delete_associations
    end
  end

  def restore
    transaction do
      update_columns(deleted: false, deleted_at: nil)
      restore_associations
    end
  end

  def destroyed?
    deleted?
  end

  class_methods do
    def with_deleted
      unscope(where: :deleted)
    end
  end

  private

  def soft_delete_associations
    self.class.reflect_on_all_associations.each do |association|
      next unless association.options[:dependent] == :destroy

      association_records = public_send(association.name)
      association_records.each(&:soft_delete)
    end
  end

  def restore_associations
    self.class.reflect_on_all_associations.each do |association|
      next unless association.options[:dependent] == :destroy

      association_records = public_send(association.name)
      association_records.each(&:restore)
    end
  end
end
