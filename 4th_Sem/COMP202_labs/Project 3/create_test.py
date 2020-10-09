import random

n = 10_000


def create():
    with open("test_file", 'wb') as f:
        for _ in range(n):
            num = random.randint(-500_000, 500_000)
            f.write(num.to_bytes(length=4, byteorder='big', signed=True))


if __name__ == "__main__":
    create()
