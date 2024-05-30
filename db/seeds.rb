r1 = Role.create!({ name: 'admin', description: 'Админ может утвердить, либо отклонить заявку на отпуск/отгул' })
r2 = Role.create!({ name: 'worker', description: 'Сотрудник может отправить заявку на отпуск/отгул' })

User.create!({ email: "admin@example.com", password: "admin", password_confirmation: "admin", role_id: r1.id })
u1 = User.create!({ email: "worker1@example.com", password: "worker1", password_confirmation: "worker1", role_id: r2.id })
u2 = User.create!({ email: "worker2@example.com", password: "worker2", password_confirmation: "worker2", role_id: r2.id })

r1 = r2 = nil

Approval.create!({ type: 'vacation', created_by_id: u1.id, period_from: Date.today, period_to: 14.days.from_now, comment: "Отпуск сотрудника", status: 'created' })
Approval.create!({ type: 'time_off', created_by_id: u1.id, period_from: 1.day.ago, period_to: 1.day.ago, comment: "Удаленный отгул сотрудника", status: 'trashed' })
Approval.create!({ type: 'vacation', created_by_id: u1.id, period_from: 1.month.ago, period_to: 1.month.ago + 14.days, comment: "Отклоненный отпуск сотрудника", status: 'denied' })

Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 7.days.ago, period_to: 7.days.ago, comment: "Удаленный отгул сотрудника", status: 'trashed'})
Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 6.days.ago, period_to: 6.days.ago, comment: "Одобренный отгул сотрудника", status: 'approved'})
Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 5.days.ago, period_to: 5.days.ago, comment: "Отклоненный отгул сотрудника", status: 'denied'})
Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 4.days.ago, period_to: 4.days.ago, comment: "Отклоненный отгул сотрудника", status: 'denied'})
Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 3.days.from_now, period_to: 3.days.from_now, comment: "Одобренный отгул сотрудника", status: 'approved'})
Approval.create!({ type: 'time_off', created_by_id: u2.id, period_from: 2.days.from_now, period_to: 2.days.from_now, comment: "Отгул сотрудника на рассмотрении", status: 'considering'})

u1 = u2 = nil