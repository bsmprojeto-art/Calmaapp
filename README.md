# App Calma - Configuração do Supabase

Para que o aplicativo funcione corretamente com todas as funcionalidades de autenticação, progresso, blog e newsletter, é **essencial** configurar seu projeto Supabase.

## 1. Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto (na mesma pasta onde está o `package.json`) com o seguinte conteúdo:

```
VITE_SUPABASE_URL=SUA_URL_DO_SUPABASE
VITE_SUPABASE_ANON_KEY=SUA_CHAVE_ANON_DO_SUPABASE
VITE_ADMIN_EMAIL=bsmprojeto@gmail.com
```

- Substitua `SUA_URL_DO_SUPABASE` pela URL do seu projeto Supabase (você encontra no painel do Supabase, em `Settings > API`).
- Substitua `SUA_CHAVE_ANON_DO_SUPABASE` pela chave `anon` do seu projeto Supabase (você encontra no painel do Supabase, em `Settings > API`).
- Mantenha `VITE_ADMIN_EMAIL` como `bsmprojeto@gmail.com` para que o login de administrador funcione.

## 2. Configuração do Banco de Dados (Supabase)

Execute o seguinte script SQL no seu editor SQL do Supabase para criar as tabelas necessárias:

```sql
CREATE TABLE blog_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  author_email TEXT
);

CREATE TABLE newsletter_subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  total_sessions INTEGER DEFAULT 0,
  total_time INTEGER DEFAULT 0, -- in minutes
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_session_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Habilitar Row Level Security (RLS) para as tabelas
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Políticas de RLS para blog_posts
CREATE POLICY "Enable read access for all users" ON blog_posts FOR SELECT USING (TRUE);
CREATE POLICY "Enable insert for admin only" ON blog_posts FOR INSERT WITH CHECK (auth.email() = 'bsmprojeto@gmail.com');

-- Políticas de RLS para newsletter_subscriptions
CREATE POLICY "Enable insert for all users" ON newsletter_subscriptions FOR INSERT WITH CHECK (TRUE);
CREATE POLICY "Enable read access for admin only" ON newsletter_subscriptions FOR SELECT USING (auth.email() = 'bsmprojeto@gmail.com');

-- Políticas de RLS para user_progress
CREATE POLICY "Enable read access for authenticated users" ON user_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable insert for authenticated users" ON user_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Enable update for authenticated users" ON user_progress FOR UPDATE USING (auth.uid() = user_id);

```

## 3. Configuração de Autenticação (Supabase)

No painel do Supabase, vá em `Authentication > Providers` e habilite o provedor `Email`.

## 4. Configuração de CORS (Supabase)

Se você estiver tendo problemas de `Failed to fetch` ou CORS, pode ser necessário adicionar o domínio do seu aplicativo à lista de domínios permitidos no Supabase. Vá em `Settings > API > CORS` e adicione a URL onde seu aplicativo está hospedado (por exemplo, `https://iioaruso.manus.space`).

Após configurar o Supabase, recompile e republique o projeto.

