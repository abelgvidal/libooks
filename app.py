import click
from flask import Flask, render_template
from flask.cli import with_appcontext
from flask_sqlalchemy import SQLAlchemy
from flask_admin.contrib.sqla import ModelView
from flask_admin import Admin
from flask_migrate import Migrate
from flask_admin.form import Select2Widget
from wtforms_sqlalchemy.fields import QuerySelectField

app = Flask(__name__)
app.config['SECRET_KEY'] = "es-shhhhh"
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

# Models
class Author(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=True)
    surname = db.Column(db.String(100), nullable=False)
    country = db.Column(db.String(100), nullable=True)        
    birth_year = db.Column(db.Integer, nullable=True)         
    death_year = db.Column(db.Integer, nullable=True)         
    notes = db.Column(db.Text, nullable=True) 

    def __str__(self):
        return self.name + ' ' + self.surname

class Book(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    author_id = db.Column(db.Integer, db.ForeignKey('author.id'), nullable=False)
    author = db.relationship('Author', backref=db.backref('books', lazy=True))
    year = db.Column(db.Integer, nullable=True)                   
    publisher = db.Column(db.String(100), nullable=True)          
    isbn = db.Column(db.String(20), nullable=True)                
    language = db.Column(db.String(50), nullable=True)
    edition = db.Column(db.String(50), nullable=True)           

    def __str__(self):
        return self.name + " " + self.surname

class AuthorView(ModelView):
    column_list = ['name', 'surname', 'country', 'birth_year', 'death_year']
    column_searchable_list = ['surname', 'country']
    form_columns = ['name', 'surname', 'country', 'birth_year', 'death_year', 'notes']


class BookView(ModelView):
    column_list = ['title', 'author', 'year']
    column_searchable_list = ['title']
    form_columns = ['title', 'author', 'year', 'publisher', 'isbn', 'language', 'edition']
    form_overrides = {
        'author': QuerySelectField
    }
    form_args = {
        'author': {
            'query_factory': lambda: Author.query.all(),
            'get_label':  lambda author: f"{author.name} {author.surname} ({author.death_year})",
            'allow_blank': False,
            'widget': Select2Widget()
        }
    }
# Admin
admin = Admin(app, name="Libooks admin", template_mode="bootstrap3")
admin.add_view(AuthorView(Author, db.session))
admin.add_view(BookView(Book, db.session))

# Public Routes
@app.route("/")
def hello_world():
    authors = Author.query.order_by(Author.death_year.desc()).all()
    print(authors)
    return render_template("index.html", authors=authors)