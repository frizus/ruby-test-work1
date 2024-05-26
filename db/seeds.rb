r1 = Role.create!({ name: 'admin', description: 'Админ может утвердить, либо отклонить заявку на отпуск/отгул' })
r2 = Role.create!({ name: 'worker', description: 'Сотрудник может отправить заявку на отпуск/отгул' })

User.create!({ email: "admin@example.com", password: "admin", password_confirmation: "admin", role_id: r1.id })
User.create!({ email: "worker@example.com", password: "worker", password_confirmation: "worker", role_id: r2.id })
