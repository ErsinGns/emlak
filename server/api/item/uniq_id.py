import uuid

def unique_user_id():
    return uuid.uuid4()


if __name__ == "__main__":
    for i in range(10):
        user_id = unique_user_id()
        print(user_id, len(str(user_id)))# 36