# Stack Hints — Squirrel 🐿️

Common pitfalls and best practices by language/stack. Read the section that matches your project.

---

## TypeScript / Node.js

**Setup:**
```bash
npm init -y
npm install -D typescript @types/node ts-node
npx tsc --init
```

**Common pitfalls:**
- `any` defeats the purpose of TypeScript — use `unknown` and narrow it
- Forgetting `await` on async functions causes subtle bugs
- `JSON.parse()` returns `any` — always validate with Zod or similar
- `process.env.FOO` is `string | undefined` — handle the undefined case
- Import paths: use `"moduleResolution": "bundler"` or `"node16"` in tsconfig

**Good patterns:**
```typescript
// Result type instead of throw
type Result<T> = { ok: true; data: T } | { ok: false; error: string }

// Validate env at startup
const PORT = process.env.PORT ? parseInt(process.env.PORT) : 3000
```

---

## Python

**Setup:**
```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

**Common pitfalls:**
- Mutable default arguments: `def f(x=[])` mutates across calls — use `None` + `if x is None: x = []`
- `except Exception` swallows everything — be specific (`except ValueError:`)
- Relative imports fail when running scripts directly — use `python -m package.module`
- `is` vs `==`: use `==` for value equality, `is` only for `None`/`True`/`False`

**Good patterns:**
```python
# Type hints + dataclass
from dataclasses import dataclass
from typing import Optional

@dataclass
class Config:
    host: str
    port: int = 8080
    debug: bool = False
```

---

## Go

**Setup:**
```bash
go mod init github.com/user/project
```

**Common pitfalls:**
- Ignoring errors: always handle `err != nil`
- Goroutine leaks: always have a done channel or context cancellation
- Nil pointer dereference: check before dereferencing pointers/interfaces
- `append` may or may not create a new backing array — don't rely on sharing

**Good patterns:**
```go
// Wrap errors with context
if err != nil {
    return fmt.Errorf("loading config: %w", err)
}
```

---

## Rust

**Setup:**
```bash
cargo new project-name
cd project-name
```

**Common pitfalls:**
- `unwrap()` in production code — use `?` and propagate errors
- `clone()` everywhere for convenience hides real design issues
- `Vec<Box<dyn Trait>>` often better replaced with enums

**Good patterns:**
```rust
// Use thiserror for library errors
#[derive(thiserror::Error, Debug)]
pub enum AppError {
    #[error("not found: {0}")]
    NotFound(String),
}
```

---

## React / Next.js

**Common pitfalls:**
- Missing `key` prop in lists causes subtle re-render bugs
- `useEffect` with wrong deps array → stale closure bugs
- Fetching in `useEffect` without cleanup → race conditions on fast navigation
- Large components — split when a component does more than one thing

**Good patterns:**
```tsx
// Co-locate related state in a custom hook
function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  // ...
  return { user, loading }
}
```

---

## REST API (Express / Fastify / Hono)

**Common pitfalls:**
- Not validating request body before using it
- Returning stack traces in production error responses
- Missing rate limiting on auth endpoints
- Not setting security headers (use `helmet`)

**Good patterns:**
```typescript
// Validate input with Zod
const schema = z.object({ email: z.string().email(), password: z.string().min(8) })

app.post('/login', async (req, res) => {
  const parsed = schema.safeParse(req.body)
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() })
  // proceed safely
})
```

---

## Databases

**Common pitfalls:**
- N+1 queries: loading related records in a loop — use JOINs or eager loading
- No indexes on foreign keys or frequently-queried columns
- Storing passwords in plaintext — always use bcrypt/argon2
- Not using transactions for multi-step writes

**Good patterns:**
- Add indexes on: foreign keys, columns in WHERE/ORDER BY clauses
- Use `EXPLAIN ANALYZE` to spot slow queries
- Paginate large result sets — never `SELECT *` without a LIMIT in production

---

## Ruby

**Setup:**
```bash
bundle install
```

**Common pitfalls:**
- `nil` propagation — use the safe navigation operator `&.` or `fetch` for hashes, but don't overuse it (hides bugs)
- Monkey-patching core classes — dangerous in libraries; prefer refinements or explicit utility modules
- N+1 in ActiveRecord — always check `.includes(:association)` for loaded relations
- `String#freeze` on literals is unnecessary since Ruby 2.3 (frozen by default for literals)

**Good patterns:**
```ruby
# Struct for value objects instead of hashes
User = Struct.new(:name, :email, keyword_init: true)
user = User.new(name: "Ada", email: "ada@example.com")

# Use dry-monads for Result types
def find_user(id)
  user = User.find_by(id: id)
  user ? Success(user) : Failure(:not_found)
end
```

---

## Java / Kotlin

**Setup:**
```bash
# Maven
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeVersion=1.4

# Gradle
gradle init
```

**Common pitfalls:**
- NullPointerException — prefer `Optional<T>` for return types, use Kotlin null-safety when possible
- Not closing resources — use try-with-resources (`try (InputStream is = ...)`)
- StringBuilder vs `+` for string concatenation in loops — `+` creates a new String each iteration
- Raw types — always use generics (`List<String>`, not `List`)

**Good patterns:**
```java
// Try-with-resources for auto-closing
try (Connection conn = dataSource.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {
    // use conn and ps
}

// Optional instead of null
public Optional<User> findById(long id) {
    return Optional.ofNullable(userRepository.findOne(id));
}
```

---

## C# / .NET

**Setup:**
```bash
dotnet new console -n MyApp
cd MyApp
dotnet add package Newtonsoft.Json  # or System.Text.Json
```

**Common pitfalls:**
- Async void — always use `async Task` or `async Task<T>`, never `async void` (except event handlers)
- Not using `ConfigureAwait(false)` in library code — causes deadlocks in non-ASP.NET contexts
- `IEnumerable<T>` multiple enumeration — materialize with `.ToList()` if iterating twice
- `==` vs `.Equals()` for value comparisons — use `.Equals()` or `StringComparer.Ordinal` for strings

**Good patterns:**
```csharp
// Async all the way
public async Task<User> GetUserAsync(int id)
{
    var user = await _repository.FindByIdAsync(id)
        .ConfigureAwait(false);
    return user ?? throw new NotFoundException($"User {id} not found");
}

// Record types for immutable data (C# 9+)
public record User(int Id, string Name, string Email);
```
