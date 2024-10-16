@bot.message_handler(commands=['approve'])
def approve_user(message):
    if not is_user_admin(message.from_user.id, message.chat.id):
        bot.send_message(message.chat.id, "*You are not authorized to use this command*", parse_mode='Markdown')
        return

    try:
        cmd_parts = message.text.split()
        if len(cmd_parts) != 4:
            bot.send_message(message.chat.id, "*Invalid command format. Use /approve <user_id>*", parse_mode='Markdown')
            return

        target_user_id = int(cmd_parts[1])

        valid_until = (datetime.now() + timedelta(days=days)).date().isoformat() if days > 0 else ""
        users_collection.update_one(
            {"user_id": target_user_id},
            
            upsert=True
        )
        bot.send_message(message.chat.id, f"*User {target_user_id} approved.*", parse_mode='Markdown')
    except Exception as e:
        bot.send_message(message.chat.id, "*PLEASE ADD MEMBER PROPERLY*", parse_mode='Markdown')
        logging.error(f"Error in approving user: {e}")