"""
This is the app file for the Cornell Craigslist App (tentative name Ezra's List)

It contains many of the methods necessary to run the app. Eventually, it will contain all of the methods.

Author: Christian Donovan (cjd237)
"""

import json
from flask_sqlalchemy import SQLAlchemy
from db import Users, Items, Offers, db #and Offers maybe (yes)
from flask import Flask, request

db_filename = 'craigslist.db'

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI']= 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_NOTIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()

#create a user
@app.route('/api/users/', methods = ['POST'])
def createUser():
	postBody = json.loads(request.data)
	name = postBody.get('name')
	password = postBody.get('password')

	user = Users(
		name = name,
		password = password
	)

	db.session.add(user)
	db.session.commit()
	return json.dumps({'success': True, 'data': user.serialize()}), 201

#get all the users
@app.route('/api/users/', methods = ['GET'])
def getAllUsers():
	users = Users.query.all()
	res = {'success': True, 'data': [u.serialize() for u in users]}
	return json.dumps(res), 200

#get a specific user
@app.route('/api/user/<int:userID>/')
def getUser(userID):
	user = Users.query.filter_by(id = userID).first()
	if not user:
		return json.dumps({'success': False, 'error': 'User not found!'})

	return json.dumps({'success': True, 'data': user.serialize()})

#create an item (listing)
@app.route('/api/items/<int:userID>/', methods = ['POST'])
def createItem(userID):
	user = Users.query.filter_by(id = userID).first()
	if not user:
		return json.dumps({'success': False, 'error': 'User not found!'})

	postBody = json.loads(request.data)
	
	name = postBody.get('name')
	description = postBody.get('description')
	category = postBody.get('category')
	price = postBody.get('price')
	ownerID = postBody.get('ownerID')

	item = Items(
		name = name,
		description = description,
		category = category,
		price = price,
		ownerID = ownerID
	)

	user.items.append(item)
	db.session.add(item)
	db.session.commit()

	return json.dumps({'success': True, 'data': item.serialize()}), 201

#create an item (listing)
@app.route('/api/items/', methods = ['POST'])
def createItemByName():
	postBody = json.loads(request.data)
	
	user = postBody.get('user')
	name = postBody.get('name')
	description = postBody.get('description')
	category = postBody.get('category')
	price = postBody.get('price')
	ownerID = postBody.get('ownerID')

	user = Users.query.filter_by(name = user).first()
	if not user:
		return json.dumps({'success': False, 'error': 'User not found!'})

	item = Items(
		name = name,
		description = description,
		category = category,
		price = price,
		ownerID = user.id

	)

	user.items.append(item)
	db.session.add(item)
	db.session.commit()

	return json.dumps({'success': True, 'data': item.serialize()}), 201

@app.route('/api/items/', methods = ['GET'])
def getAllItems():
	items = Items.query.all()
	res = {'success': True, 'data': [i.serialize() for i in items]}
	return json.dumps(res), 200

@app.route('/api/items/search/', methods = ['POST'])
def getCategoryItems():
	postBody = json.loads(request.data)
	category = postBody.get('category')
	items = Items.query.filter_by(category = category).all()

	return json.dumps({'success': True, 'data': [i.serialize() for i in items]}), 200


@app.route('/api/items/<int:itemID>/', methods = ['DELETE'])
def deleteItem(itemID):
	item = Items.query.filter_by(id = itemID).first()
	if not item:
		return json.dumps({'success': False, 'error': 'Item not found!'})
	else:
		db.session.delete(item)
		db.session.commit()
		return json.dumps({'success': True, 'data': 'Item deleted'}), 200



#get all items of a user
@app.route('/api/items/<int:userID>/')
def getUserItems(userID):
	user = Users.query.filter_by(id = userID).first()
	if not user:
		return json.dumps({'success': False, 'error': 'User not found'}), 404

	items = user.items

	return json.dumps({'success': True, 'data': [i.serialize() for i in items]}), 200

#get a specific item
@app.route('/api/items/item/<int:itemID>/')
def getItem(itemID):
	item = Items.query.filter_by(id = itemID).first()
	if not item:
		return json.dumps({'success': False, 'error': 'Item not found!'})

	return json.dumps({'success': True, 'data': item.serialize()})

@app.route('/api/items/item/<int:itemID>/edit/', methods = ['POST'])
def editItem(itemID):
	postBody = json.loads(request.data)
	item = Items.query.filter_by(id = itemID).first()
	if not item:
		return json.dumps({'success': False, 'error': 'Item not found!'})

	newPrice = postBody.get('price')
	newName = postBody.get('name')
	newDescription = postBody.get('description')

	if newPrice != None:
		item.price = newPrice
	if newName != None:
		item.name = newName
	if newDescription != None:
		item.description = newDescription

	return json.dumps({'success': True, 'data': item.serialize()})




#Methods for offers

#Create an offer to buy an item
@app.route('/api/offers/', methods = ['POST'])
def createOffer():
	postBody = json.loads(request.data)

	itemID = postBody.get('itemID')

	senderID = postBody.get('senderID')
	ownerID = postBody.get('ownerID')
	money = postBody.get('money')
	location = postBody.get('location')


	owner = Users.query.filter_by(id = ownerID).first()
	
	sender = Users.query.filter_by(id = senderID).first()
	
	item = Items.query.filter_by(id = itemID, ownerID = ownerID).first()


	if not owner:
		return json.dumps({'success': False, 'error': 'Owner not found!'}), 404
	if not sender:
		return json.dumps({'success': False, 'error': 'Sender not found!'}), 404
	if not item:
		return json.dumps({'success': False, 'error': 'item not found!'}), 404
	if ownerID == senderID:
		return json.dumps({'success': False, 'error': 'Sender and Owner are the same user'}), 404

	offer = Offers(
		itemID = itemID,
		senderID = senderID,
		ownerID = ownerID, #or item.getOwnerID()? I think that would be better
		money = money,
		location = location
	)

	#add to a user??
	db.session.add(offer)
	sender.offersMade.append(offer)
	#owner.offersReceived.append(offer)
	item.offersOn.append(offer)
	
	db.session.commit()

	return json.dumps({'success': True, 'data': offer.serialize()}), 201

#get an offer
@app.route('/api/offers/<int:offerID>/')
def getOffer(offerID):
	offer = Offers.query.filter_by(id = offerID).first()
	if not offer:
		return json.dumps({'success': False, 'error': 'Offer not found!'})

	return json.dumps({'success': True, 'data': offer.serialize()}), 200

@app.route('/api/offers/<int:offerID>/accept/', methods = ['POST'])
def acceptOffer(offerID):
	offer = Offers.query.filter_by(id = offerID).first()
	postBody = json.loads(request.data)
	senderID = postBody.get('ownerID')

	if not offer:
		return json.dumps({'success': False, 'error': 'Offer not found!'}), 404
	if offer.ownerID == senderID:
		return json.dumps({'success': False, 'error': 'You cannot accept your own offer'}), 404

	#removePendingOffer(offerID)

	offer.accepted = True
	return json.dumps({'success': True, 'data': offer.serialize()}), 200

def removePendingOffer(offerID):
	offer = Offers.query.filter_by(id = offerID).first()
	owner = Users.query.filter_by(id = offer.ownerID).first()

	owner.offersReceived.remove(offer)

	return json.dumps({'success': True, 'data': offer.serialize()}), 200

#allows code to be called as a .exe
if __name__ == '__main__':
    app.run(host = '0.0.0.0', port = 5000, debug = True) 



