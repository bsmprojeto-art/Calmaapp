# 🚀 Guia de Deploy - App Calma

Este guia te ajudará a fazer o deploy do App Calma no seu domínio próprio usando GitHub Pages, Netlify ou Vercel.

## 📋 Pré-requisitos

1. ✅ Conta no GitHub
2. ✅ Conta no Netlify, Vercel ou GitHub Pages habilitado
3. ✅ Domínio próprio configurado
4. ✅ Projeto Supabase configurado (já feito!)

## 🎯 Opções de Deploy

### Opção 1: Netlify (Recomendado)

#### Passo 1: Preparar o Repositório
1. Crie um repositório no GitHub
2. Faça upload de todos os arquivos do projeto
3. Certifique-se que o arquivo `netlify.toml` está na raiz

#### Passo 2: Deploy no Netlify
1. Acesse [netlify.com](https://netlify.com)
2. Clique em "New site from Git"
3. Conecte seu repositório GitHub
4. Configure:
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
5. Clique em "Deploy site"

#### Passo 3: Configurar Domínio Próprio
1. No painel do Netlify, vá em "Domain settings"
2. Clique em "Add custom domain"
3. Digite seu domínio (ex: `meusite.com`)
4. Configure os DNS do seu domínio:
   - Adicione um registro CNAME apontando para `[seu-site].netlify.app`
   - Ou configure os nameservers do Netlify

### Opção 2: Vercel

#### Passo 1: Preparar o Repositório
1. Crie um repositório no GitHub
2. Faça upload de todos os arquivos do projeto
3. Certifique-se que o arquivo `vercel.json` está na raiz

#### Passo 2: Deploy no Vercel
1. Acesse [vercel.com](https://vercel.com)
2. Clique em "New Project"
3. Importe seu repositório GitHub
4. O Vercel detectará automaticamente as configurações
5. Clique em "Deploy"

#### Passo 3: Configurar Domínio Próprio
1. No painel do Vercel, vá em "Domains"
2. Adicione seu domínio personalizado
3. Configure os DNS conforme as instruções do Vercel

### Opção 3: GitHub Pages

#### Passo 1: Preparar o Repositório
1. Crie um repositório no GitHub
2. Faça upload de todos os arquivos do projeto
3. O arquivo `.github/workflows/deploy.yml` já está configurado

#### Passo 2: Habilitar GitHub Pages
1. No repositório, vá em "Settings" > "Pages"
2. Em "Source", selecione "GitHub Actions"
3. O deploy será automático a cada push na branch `main`

#### Passo 3: Configurar Domínio Próprio
1. No repositório, vá em "Settings" > "Pages"
2. Em "Custom domain", digite seu domínio
3. Configure um registro CNAME no seu DNS apontando para `[seu-usuario].github.io`

## 🔧 Configurações Importantes

### Variáveis de Ambiente
Todas as variáveis já estão configuradas nos arquivos:
- `VITE_SUPABASE_URL`: https://yumofgfdqdnttaoimvjt.supabase.co
- `VITE_SUPABASE_ANON_KEY`: [sua chave anon]
- `VITE_ADMIN_EMAIL`: bsmprojeto@gmail.com

### Configuração do Supabase
Execute este SQL no seu projeto Supabase (já está no arquivo `supabase-setup.sql`):

```sql
-- Criar tabelas
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
  name TEXT,
  subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  total_sessions INTEGER DEFAULT 0,
  total_time INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_session_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança
CREATE POLICY "Enable read access for all users" ON blog_posts FOR SELECT USING (TRUE);
CREATE POLICY "Enable insert for admin only" ON blog_posts FOR INSERT WITH CHECK (auth.email() = 'bsmprojeto@gmail.com');

CREATE POLICY "Enable insert for all users" ON newsletter_subscriptions FOR INSERT WITH CHECK (TRUE);
CREATE POLICY "Enable read access for admin only" ON newsletter_subscriptions FOR SELECT USING (auth.email() = 'bsmprojeto@gmail.com');

CREATE POLICY "Enable read access for authenticated users" ON user_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Enable insert for authenticated users" ON user_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Enable update for authenticated users" ON user_progress FOR UPDATE USING (auth.uid() = user_id);
```

## 🎉 Funcionalidades Disponíveis

Após o deploy, seu site terá:

✅ **Sistema de Login/Cadastro**
✅ **Painel Administrativo** (login: bsmprojeto@gmail.com)
✅ **Blog com CRUD completo**
✅ **Newsletter funcional**
✅ **Sistema de Progresso do usuário**
✅ **Meditação com sons ambiente**
✅ **Livro completo de mindfulness**
✅ **Práticas de reconexão emocional**
✅ **Seção de compartilhamento**
✅ **Suporte a idiomas (PT/EN)**
✅ **Design responsivo**

## 🆘 Suporte

Se tiver algum problema:
1. Verifique se todas as variáveis de ambiente estão configuradas
2. Confirme que o SQL foi executado no Supabase
3. Teste o site localmente primeiro com `npm run dev`
4. Verifique os logs de build na plataforma escolhida

## 🔗 Links Úteis

- [Documentação Netlify](https://docs.netlify.com/)
- [Documentação Vercel](https://vercel.com/docs)
- [Documentação GitHub Pages](https://docs.github.com/en/pages)
- [Documentação Supabase](https://supabase.com/docs)

---

**Seu App Calma está pronto para o mundo! 🧘‍♀️✨**

