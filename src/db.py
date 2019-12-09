"""
This is the database and ORM file for the Cornell Craigslist app. 

It contains the setup and structure for each table that will be necessary for this app.
One or more tables still need to be created, depending on the specific requirements of the app.

Author: cjd237
"""
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# user_offer = db.Table('user_offer', db.Model.metadata,
#     db.Column('offerID', db.Integer, db.ForeignKey('offers.id')),
#     db.Column('userID', db.Integer, db.ForeignKey('users.id'))
# )

# item_offer = db.Table('item_offer', db.Model.metadata,
#     db.Column('offerID', db.Integer, db.ForeignKey('offers.id')),
#     db.Column('itemID', db.Integer, db.ForeignKey('item.id'))
# )


class Users(db.Model):
	"""
	Class to represent a table of users of the service
	"""
	__tablename__ = 'users'

	id = db.Column(db.Integer, primary_key = True, autoincrement = True)
	name = db.Column(db.String, nullable = False)
	#not hashed for now
	password = db.Column(db.String, nullable = False)
	items = db.relationship('Items', cascade = 'delete')
	offersMade = db.relationship('Offers', cascade = 'delete')

	def __init__(self, **kwargs):
		self.name = kwargs.get('name')
		self.password = kwargs.get('password')
		self.items = []
		self.offersMade = []
		self.offersReceived = []

	def serialize(self):
		return{
			'id': self.id, 
			'name': self.name,
			'items': [i.serialize() for i in self.items]
			#'offers received': [r.serialize() for r in self.offersReceived]
		}

	def serializeForItem(self):
		return{
			'id': self.id, 
			'name': self.name
		}

	def getID(self):
		return self.id

	def getName(self):
		return self.name


class Items(db.Model):
	"""
	Class to represent a table of items of the service.

	Items will be associated with a user ('owner') and have a price.
	"""
	__tablename__ = 'items'
	id = db.Column(db.Integer, primary_key = True, autoincrement = True)
	name = db.Column(db.String, nullable = False)
	description = db.Column(db.String)
	price = db.Column(db.String, nullable = False)
	category = db.Column(db.String)
	offersOn = db.relationship('Offers', cascade = 'delete')

	#db relationships for the owner and offers
	ownerID = db.Column(db.Integer, db.ForeignKey('users.id'))

	def __init__(self, **kwargs):
		self.name = kwargs.get('name')
		self.price = kwargs.get('price')
		self.description = kwargs.get('description')
		self.category = kwargs.get('category')
		self.ownerID = kwargs.get('ownerID')

	def serialize(self):
		return{
			'id': self.id,
			'name': self.name,
			'description': self.description,
			'category': self.category,
			'price': self.price,

			#think about this later to prevent recursion
			'owner': {
				'id': Users.query.filter_by(id=self.ownerID).first().getID(), 
				'name': Users.query.filter_by(id=self.ownerID).first().getName()

			},

		}

	def getOwnerID(self):
		return self.ownerID


class Offers(db.Model):
	"""
	Class to represent pending and approved offers for items from other users.

	A many to many relationship here, between users and other users items.
	"""
	__tablename__ = 'offers'
	id = db.Column(db.Integer, primary_key = True, autoincrement = True)
	itemID = db.Column(db.Integer, db.ForeignKey('items.id'))
	senderID = db.Column(db.Integer, db.ForeignKey('users.id'))
	ownerID = db.Column(db.Integer, nullable = False)
	money = db.Column(db.Float, nullable = False)
	location = db.Column(db.String)
	accepted = db.Column(db.Boolean)
	#owner = db.relationship('User', back_populates = 'offers')
	#sender = db.relationship('User', back_populates = 'offers')

	def __init__(self, **kwargs):
		self.itemID = kwargs.get('itemID')
		self.senderID = kwargs.get('senderID')
		self.ownerID = kwargs.get('ownerID')
		self.money = kwargs.get('money')
		self.location = kwargs.get('location')
		self.accepted = False


	def serialize(self):
		return{
			'id': self.id,
			'money offered': self.money,
			'location': self.location,
			'owner': {
				'id': Users.query.filter_by(id=self.ownerID).first().getID(), 
				'name': Users.query.filter_by(id=self.ownerID).first().getName()

			},
			'sender': {
				'id': Users.query.filter_by(id=self.senderID).first().getID(), 
				'name': Users.query.filter_by(id=self.senderID).first().getName()
			},
			'accepted': self.accepted

			#uhhh do this later to prevent recursion
		}



