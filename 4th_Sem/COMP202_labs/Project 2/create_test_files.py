"""Create len(files) with random numbers inside. Utilized Pool for faster execution
"""


from multiprocessing import Pool
import random

files = [10, 50, 100, 1000, 1_500, 5_000, 10_000, 15_000, 100_000, 500_000, 750_000, 1_000_000]


def create(n):
    with open("test_" + str(n), 'wb') as f:
        for i in range(n):
            num = random.randint(-500_000, 500_000)
            f.write(num.to_bytes(4, 'little', signed=True))


if __name__ == "__main__":
    with Pool(processes=10) as pool:
        pool.map(create, files)
