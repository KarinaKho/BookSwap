-- BookSwap: схема базы данных (PostgreSQL)

CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    university  VARCHAR(150),
    faculty     VARCHAR(150),
    rating      NUMERIC(3, 2) DEFAULT 0,
    created_at  TIMESTAMP DEFAULT now()
);

CREATE TABLE books (
    id       SERIAL PRIMARY KEY,
    title    VARCHAR(255) NOT NULL,
    author   VARCHAR(255),
    isbn     VARCHAR(20),
    subject  VARCHAR(150),
    year     SMALLINT
);

CREATE TABLE listings (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    book_id    INTEGER NOT NULL REFERENCES books (id),
    condition  VARCHAR(20) CHECK (condition IN ('new', 'good', 'worn')),
    status     VARCHAR(20) DEFAULT 'available'
               CHECK (status IN ('available', 'reserved', 'exchanged')),
    created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE exchange_requests (
    id            SERIAL PRIMARY KEY,
    listing_id    INTEGER NOT NULL REFERENCES listings (id) ON DELETE CASCADE,
    requester_id  INTEGER NOT NULL REFERENCES users (id),
    status        VARCHAR(20) DEFAULT 'pending'
                  CHECK (status IN ('pending', 'accepted', 'rejected', 'done')),
    meeting_place VARCHAR(255),
    created_at    TIMESTAMP DEFAULT now()
);

CREATE TABLE reviews (
    id         SERIAL PRIMARY KEY,
    author_id  INTEGER NOT NULL REFERENCES users (id),
    target_id  INTEGER NOT NULL REFERENCES users (id),
    score      SMALLINT CHECK (score BETWEEN 1 AND 5),
    text       TEXT,
    CHECK (author_id <> target_id)
);

CREATE INDEX idx_books_subject ON books (subject);
CREATE INDEX idx_listings_status ON listings (status);
