import matplotlib.pyplot as plt

x = []
y = []
n = 0

with open('data.txt', 'r') as file:
    for line in file:
        n += 1
        columns = line.split()
        x.append(int(columns[0]))
        y.append(int(columns[1]))

print(f"Read {n} lines")

plt.plot(x, y, linestyle="-.", color='red')
plt.title('data.txt')
plt.xlabel('x')
plt.ylabel('y')
plt.savefig('data.pdf')
plt.show()