component extends="coldbox.system.testing.BaseTestCase" appMapping="/root"{

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
		new coldbox.system.ioc.Injector(binder="tests.resources.WireBox");
	}

	function setup(){
		/**
			mockController = getMockBox().createEmptyMock("coldbox.system.web.Controller");
		mockLogger   = getMockBox().createEmptyMock("coldbox.system.logging.Logger").$("canDebug",true).$("debug");
		mockLogBox   = getMockBox().createEmptyMock("coldbox.system.logging.LogBox")
			.$("getLogger", mockLogger);
		mockController.$("getLogBox", mockLogBox);
		mockController.$("getCacheBox", "");
		**/

		application.wirebox = new coldbox.system.ioc.Injector(binder="tests.resources.WireBox");
		criteria   = getMockBox().createMock("cborm.models.CriteriaBuilder");
		criteria.init( entityName="User", ormService=new cborm.models.BaseORMService() );

		// Test ID's
		testUserID = '88B73A03-FEFA-935D-AD8036E1B7954B76';
		testCatID  = '3A2C516C-41CE-41D3-A9224EA690ED1128';
		test2 = ["1","2"];
	}

	function testGet(){
		r = criteria.idEQ(testUserID).get();
		assertEquals( testUserID, r.getID() );
	}

	function testTimeout(){
		r = criteria.timeout(10);
	}

	function testReadOnly(){
		r = criteria.readOnly();
		r = criteria.readOnly(false);
	}

	function testMaxResults(){
		r = criteria.maxResults(10);
	}

	function testFirstResult(){
		r = criteria.firstResult(10);
	}

	function testFetchSize(){
		r = criteria.fetchSize(10);
	}

	function testCache(){
		r = criteria.cache();
		r = criteria.cache(false);
		r = criteria.cache(true,"pio");
	}

	function testCacheRegion(){
		r = criteria.cacheRegion("pio");
	}

	function testCount(){
		criteria.init( entityName="User", ormService=new cborm.models.BaseORMService() );
		r = criteria.count();
		count = new Query(datasource="coolblog", sql="select count(*) allCount from users").execute().getResult();
		assertEquals( count.allCount , r );

		r = criteria.count("id");
		assertEquals( count.allCount , r );
	}

	function testList(){
		r = criteria.list();
		assertTrue( arrayLen(r) );

		r = criteria.list(max=1);
		assertEquals( 1, arrayLen(r) );

		r = criteria.list(max=1,offset=2);
		assertEquals( 1, arrayLen(r) );

		r = criteria.list(timeout=2);
		assertEquals( 1, arrayLen(r) );

		criteria.init( entityName="User", ormService=new cborm.models.BaseORMService() );
		r = criteria.list(sortOrder="lastName asc, firstName desc");
		assertTrue( arrayLen(r) );
	}

	function testCreateSubcriteria(){
		s = getMockBox().createMock("cborm.models.DetachedCriteriaBuilder");
		assertTrue( isInstanceOf( s, "cborm.models.DetachedCriteriaBuilder" ) );
	}

	function testConvertIDValueToJavaType(){

		test = criteria.convertIDValueToJavaType(id=1);
		assertEquals( [1], test );

		test = criteria.convertIDValueToJavaType(id=["1","2","3"]);
		assertEquals( [1,2,3], test );
	}

	function testConvertValueToJavaType(){

		test = criteria.convertValueToJavaType(propertyName="id",value=testUserID);
		assertEquals( testUserID, test );

	}
}