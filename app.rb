

require 'sinatra'                                    # подключаем библиотеку Sinatra
require 'sqlite3'                                    # подключаем библиотеку SQLite3

def get_db                                           # функция "получить базу данных"
	@db = SQLite3::Database.new 'base.db'              # @db = переменная-база
	@db.results_as_hash = true                         # можно возвращать результат как хеш
	return @db                                         # вернуть переменную-базу
end

def get_posts                                        # функция "получить все посты"
	get_db                                             # получить базу данных
	@posts = @db.execute 'SELECT * FROM Posts'         # @posts = все посты базы данных    
	@db.close                                          # закрыть базу данных
end

configure do                                         # конфигурация базы данных
	get_db
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"post_title" TEXT,
			"post_body" TEXT
		)'
	@db.close
end

get '/' do                                # обработка /
	@title = "My Blog"                      # название блога
	get_posts                               # получить все посты 
	erb :index                              # вызвать вьюху index
end

get '/new' do                             # обработка /new
	@title = "My Blog - New Post"           # название блога
	erb :new                                # вызвать вьюху new 
end 

post '/new' do                            # обработка /new (пришел post)
	@title = 'New post is posted'           # название
	@post_title = params[:post_title]       # заголовок поста
	@post_body = params[:post_body]         # тело поста
	get_db                                  # получить базу
	@db.execute 'INSERT INTO Posts (post_title, post_body) VALUES (?,?)', [@post_title, @post_body]
	@db.close                               # закрыть базу
	erb :posted                             # вызвать вьюху posted
end

get '/admin' do                           # обработка /admin
	@title = "My Blog - Admin Panel"        # заголовок
	get_posts                               # получить все посты
	erb :admin                              # вызвать вьюху admin
end