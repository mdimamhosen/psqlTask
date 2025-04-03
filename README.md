# PostgreSQL সম্পর্কিত সাধারণ প্রশ্ন ও উত্তর

## 1. PostgreSQL কী?

PostgreSQL একটি **ওপেন-সোর্স, শক্তিশালী রিলেশনাল ডাটাবেস ম্যানেজমেন্ট সিস্টেম (RDBMS)**। এটি **SQL** ভাষা ব্যবহার করে এবং উন্নত বৈশিষ্ট্য যেমন **ACID কমপ্লায়েন্স, এক্সটেনসিবিলিটি, JSON সাপোর্ট, এবং ফুল-টেক্সট সার্চ** প্রদান করে। এটি ছোট থেকে বড় যেকোনো স্কেলের ডাটাবেস ব্যবস্থাপনার জন্য উপযুক্ত।

---

## 2. PostgreSQL-এ ডাটাবেস স্কিমার উদ্দেশ্য কী?

PostgreSQL-এ **স্কিমা** হল একটি **লজিক্যাল গ্রুপিং** যা ডাটাবেসের বিভিন্ন **টেবিল, ভিউ, ফাংশন, এবং অন্যান্য অবজেক্টগুলো** সংরক্ষণ করতে সহায়তা করে।

### **স্কিমার সুবিধাসমূহ:**

- **ডাটাবেস সংগঠিত রাখা** সহজ হয়।
- **একাধিক ইউজার এবং অ্যাপ্লিকেশন** একসাথে একই ডাটাবেস ব্যবহার করতে পারে।
- **নাম সংঘর্ষ (name conflicts)** এড়াতে সাহায্য করে।

স্কিমা তৈরির জন্য:

```sql
CREATE SCHEMA sales;
```

---

## 3. Primary Key ও Foreign Key কী?

### **Primary Key (PK):**

- এটি একটি **অনন্য আইডেন্টিফায়ার** যা **প্রত্যেক সারির জন্য ইউনিক** হতে হবে।
- এক টেবিলে **একটি মাত্র Primary Key** থাকতে পারে।

### **Foreign Key (FK):**

- এটি **একটি টেবিলের কলাম** যা **অন্য একটি টেবিলের Primary Key**-কে রেফারেন্স করে।
- এটি **দুই টেবিলের মধ্যে সম্পর্ক তৈরি করে**।

#### **উদাহরণ:**

```sql
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author_id INT REFERENCES authors(author_id) ON DELETE CASCADE
);
```

---

## 4. VARCHAR ও CHAR-এর মধ্যে পার্থক্য কী?

| বৈশিষ্ট্য    | VARCHAR(n)                                   | CHAR(n)                                                   |
| ------------ | -------------------------------------------- | --------------------------------------------------------- |
| ডাটা স্টোরেজ | **ভ্যারিয়েবল দৈর্ঘ্যের** টেক্সট সংরক্ষণ করে | **নির্দিষ্ট দৈর্ঘ্যের** টেক্সট সংরক্ষণ করে                |
| ফাঁকা স্থান  | **ফাঁকা স্থান সংরক্ষণ করে না**               | **ফাঁকা স্থান সংরক্ষণ করে**                               |
| ব্যবহার      | যখন ভ্যারিয়েবল দৈর্ঘ্যের টেক্সট প্রয়োজন      | নির্দিষ্ট দৈর্ঘ্যের তথ্য যেমন, `CHAR(2)` দেশের কোডের জন্য |

উদাহরণ:

```sql
CREATE TABLE example (
    name VARCHAR(50),
    code CHAR(3)
);
```

---

## 5. WHERE ক্লজের উদ্দেশ্য কী?

`WHERE` ক্লজ ব্যবহার করা হয় **নির্দিষ্ট শর্ত অনুযায়ী ডাটাগুলো ফিল্টার করতে**।

#### **উদাহরণ:**

```sql
SELECT * FROM books WHERE author_id = 1;
```

এই কোয়েরি **শুধুমাত্র ঐ বইগুলো দেখাবে যেখানে `author_id = 1`।**

---

## 6. LIMIT এবং OFFSET ক্লজের ব্যবহার কী?

- **`LIMIT`** → ফলাফলের সংখ্যা সীমিত করে।
- **`OFFSET`** → নির্দিষ্ট সংখ্যক সারি বাদ দিয়ে পরে থেকে ফলাফল দেখায়।

#### **উদাহরণ: পেজিনেশন (Pagination)**

```sql
SELECT * FROM books ORDER BY title ASC LIMIT 10 OFFSET 20;
```

- **প্রথম ২০টি সারি বাদ দিয়ে** পরবর্তী **১০টি সারি** দেখাবে।

---

## 7. UPDATE ব্যবহার করে কীভাবে ডাটা পরিবর্তন করবেন?

`UPDATE` স্টেটমেন্ট ব্যবহার করে বিদ্যমান রেকর্ড আপডেট করা হয়।

#### **উদাহরণ:**

```sql
UPDATE books SET price = price * 1.1 WHERE published_year < 2020;
```

এটি **২০২০ সালের আগে প্রকাশিত বইগুলোর মূল্য ১০% বাড়াবে।**

---

## 8. JOIN অপারেশন কী এবং এটি কিভাবে কাজ করে?

JOIN ব্যবহার করা হয় **একাধিক টেবিলের তথ্য একসাথে আনতে**।

### **JOIN-এর ধরনসমূহ:**

1. **INNER JOIN** → শুধুমাত্র মিলে যাওয়া রেকর্ডগুলো দেখায়।
2. **LEFT JOIN** → বাম টেবিলের সব রেকর্ড দেখায়, ডান টেবিলের সাথে মিল থাকলে সেটাও।
3. **RIGHT JOIN** → ডান টেবিলের সব রেকর্ড দেখায়, বাম টেবিলের সাথে মিল থাকলে সেটাও।
4. **FULL JOIN** → উভয় টেবিলের সব রেকর্ড দেখায়।

#### **INNER JOIN উদাহরণ:**

```sql
SELECT books.title, authors.name
FROM books
INNER JOIN authors ON books.author_id = authors.author_id;
```

---

## 9. GROUP BY ক্লজ কী এবং এটি কিভাবে কাজ করে?

`GROUP BY` ক্লজ ব্যবহার করা হয় **একই ধরণের তথ্যকে গ্রুপ করে** নির্দিষ্ট গণনা (aggregation) করার জন্য।

#### **উদাহরণ:** প্রতিটি লেখকের কতগুলো বই আছে তা বের করা

```sql
SELECT author_id, COUNT(*) AS book_count
FROM books
GROUP BY author_id;
```

---

## 10. COUNT(), SUM(), এবং AVG() কিভাবে ব্যবহার করবেন?

PostgreSQL-এ **aggregate functions** ডাটা বিশ্লেষণে ব্যবহৃত হয়।

| ফাংশন         | ব্যবহার                       |
| ------------- | ----------------------------- |
| `COUNT(*)`    | মোট সারির সংখ্যা গণনা করে     |
| `SUM(column)` | একটি কলামের মোট যোগফল বের করে |
| `AVG(column)` | একটি কলামের গড় নির্ণয় করে   |

#### **উদাহরণ:**

```sql
SELECT COUNT(*) AS total_books,
       SUM(price) AS total_price,
       AVG(price) AS avg_price
FROM books;
```

- মোট বইয়ের সংখ্যা দেখাবে।
- মোট মূল্যের যোগফল দেখাবে।
- বইগুলোর গড় মূল্য নির্ণয় করবে।
