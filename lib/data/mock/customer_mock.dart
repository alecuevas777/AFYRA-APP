import 'package:afyra/models/customer.dart';
import 'package:afyra/models/sale.dart';

DateTime _ago({int days = 0, int minutes = 0}) {
  return DateTime.now().subtract(Duration(days: days, minutes: minutes));
}

Sale _sale({
  required String id,
  required int number,
  required String name,
  required String phone,
  required DateTime at,
  required List<SaleLine> lines,
  SaleStatus status = SaleStatus.completed,
  PaymentMethod payment = PaymentMethod.transfer,
  int discount = 0,
}) {
  return Sale(
    id: id,
    number: number,
    customerName: name,
    customerPhone: phone,
    at: at,
    status: status,
    payment: payment,
    discount: discount,
    lines: lines,
  );
}

const _polera = SaleLine(
  productName: 'Polera Oversize Negra',
  variantLabel: 'Negro / M',
  quantity: 1,
  unitPrice: 24990,
  estimatedUnitCost: 11600,
);

const _hoodie = SaleLine(
  productName: 'Hoodie Essential',
  variantLabel: 'Negro / M',
  quantity: 1,
  unitPrice: 39990,
  estimatedUnitCost: 24600,
);

const _crop = SaleLine(
  productName: 'Crop Top Basic',
  variantLabel: 'Blanco / M',
  quantity: 1,
  unitPrice: 12990,
  estimatedUnitCost: 6000,
);

const _jeans = SaleLine(
  productName: 'Jeans Wide Leg',
  variantLabel: 'Azul / 38',
  quantity: 1,
  unitPrice: 42990,
  estimatedUnitCost: 24000,
);

const _basic = SaleLine(
  productName: 'Polera Básica Blanca',
  variantLabel: 'Blanco / M',
  quantity: 1,
  unitPrice: 18990,
  estimatedUnitCost: 9000,
);

List<Customer> buildMockCustomers() {
  const camilaPhone = '+56 9 1111 2201';
  const javieraPhone = '+56 9 1111 2202';
  const fernandaPhone = '+56 9 1111 2203';
  const valentinaPhone = '+56 9 1111 2204';
  const sofiaPhone = '+56 9 1111 2205';
  const martinaPhone = '+56 9 1111 2206';

  return [
    Customer(
      id: 'camila',
      name: 'Camila Rojas',
      phone: camilaPhone,
      whatsapp: camilaPhone,
      instagram: '@camilarojas',
      address: 'Providencia, Santiago',
      notes: 'Casi siempre pide negro, talla M.',
      joinedAt: _ago(days: 140),
      purchases: [
        _sale(
          id: '248',
          number: 248,
          name: 'Camila Rojas',
          phone: camilaPhone,
          at: _ago(minutes: 20),
          payment: PaymentMethod.transfer,
          discount: 5000,
          lines: const [
            _polera,
            SaleLine(
              productName: 'Hoodie Essential',
              variantLabel: 'Beige / L',
              quantity: 1,
              unitPrice: 39990,
              estimatedUnitCost: 24600,
            ),
          ],
        ),
        _sale(
          id: 'c-camila-crop',
          number: 231,
          name: 'Camila Rojas',
          phone: camilaPhone,
          at: _ago(days: 3),
          payment: PaymentMethod.debit,
          lines: const [_crop],
        ),
        _sale(
          id: 'c-camila-polera',
          number: 198,
          name: 'Camila Rojas',
          phone: camilaPhone,
          at: _ago(days: 20),
          lines: const [_polera],
        ),
        _sale(
          id: '243',
          number: 243,
          name: 'Camila Rojas',
          phone: camilaPhone,
          at: _ago(days: 12),
          status: SaleStatus.cancelled,
          payment: PaymentMethod.other,
          lines: const [_basic],
        ),
      ],
    ),
    Customer(
      id: 'javiera',
      name: 'Javiera Soto',
      phone: javieraPhone,
      whatsapp: javieraPhone,
      instagram: '@javierasoto',
      address: 'Ñuñoa, Santiago',
      joinedAt: _ago(days: 90),
      purchases: [
        _sale(
          id: '247',
          number: 247,
          name: 'Javiera Soto',
          phone: javieraPhone,
          at: _ago(minutes: 90),
          payment: PaymentMethod.cash,
          lines: const [_hoodie],
        ),
        _sale(
          id: 'c-javiera-crop',
          number: 226,
          name: 'Javiera Soto',
          phone: javieraPhone,
          at: _ago(days: 5),
          payment: PaymentMethod.transfer,
          lines: const [_crop],
        ),
        _sale(
          id: 'c-javiera-jeans',
          number: 190,
          name: 'Javiera Soto',
          phone: javieraPhone,
          at: _ago(days: 18),
          lines: const [_jeans],
        ),
      ],
    ),
    Customer(
      id: 'fernanda',
      name: 'Fernanda Muñoz',
      phone: fernandaPhone,
      whatsapp: fernandaPhone,
      notes: 'Compra cuando hay drop de poleras.',
      joinedAt: _ago(days: 60),
      purchases: [
        _sale(
          id: '245',
          number: 245,
          name: 'Fernanda Muñoz',
          phone: fernandaPhone,
          at: _ago(days: 1, minutes: 40),
          payment: PaymentMethod.credit,
          discount: 6498,
          lines: const [
            _polera,
            SaleLine(
              productName: 'Hoodie Essential',
              variantLabel: 'Negro / L',
              quantity: 1,
              unitPrice: 39990,
              estimatedUnitCost: 24600,
            ),
          ],
        ),
      ],
    ),
    Customer(
      id: 'valentina',
      name: 'Valentina Pérez',
      phone: valentinaPhone,
      whatsapp: valentinaPhone,
      address: 'La Reina, Santiago',
      joinedAt: _ago(days: 40),
      purchases: [
        _sale(
          id: '244',
          number: 244,
          name: 'Valentina Pérez',
          phone: valentinaPhone,
          at: _ago(days: 8),
          status: SaleStatus.pending,
          lines: const [_jeans],
        ),
      ],
    ),
    Customer(
      id: 'sofia',
      name: 'Sofía Contreras',
      phone: sofiaPhone,
      whatsapp: '+56 9 1111 2295',
      instagram: '@sofia.studio',
      address: 'Las Condes, Santiago',
      notes: 'Retira en el local los sábados.',
      joinedAt: _ago(days: 200),
      purchases: [
        _sale(
          id: 'c-sofia-1',
          number: 240,
          name: 'Sofía Contreras',
          phone: sofiaPhone,
          at: _ago(days: 2),
          lines: const [_polera, _crop],
        ),
        _sale(
          id: 'c-sofia-2',
          number: 214,
          name: 'Sofía Contreras',
          phone: sofiaPhone,
          at: _ago(days: 16),
          payment: PaymentMethod.debit,
          lines: const [_hoodie],
        ),
        _sale(
          id: 'c-sofia-3',
          number: 176,
          name: 'Sofía Contreras',
          phone: sofiaPhone,
          at: _ago(days: 35),
          lines: const [_basic],
        ),
        _sale(
          id: 'c-sofia-4',
          number: 151,
          name: 'Sofía Contreras',
          phone: sofiaPhone,
          at: _ago(days: 70),
          payment: PaymentMethod.cash,
          lines: const [_jeans],
        ),
      ],
    ),
    Customer(
      id: 'martina',
      name: 'Martina Fuentes',
      phone: martinaPhone,
      whatsapp: martinaPhone,
      joinedAt: _ago(days: 10),
      purchases: [
        _sale(
          id: 'c-martina-1',
          number: 236,
          name: 'Martina Fuentes',
          phone: martinaPhone,
          at: _ago(days: 4),
          payment: PaymentMethod.transfer,
          lines: const [_basic],
        ),
      ],
    ),
    Customer(
      id: 'antonia',
      name: 'Antonia Reyes',
      phone: '+56 9 1111 2207',
      whatsapp: '+56 9 1111 2207',
      notes: 'Pidió que la avisemos del próximo drop.',
      joinedAt: _ago(days: 80),
    ),
    Customer(
      id: 'daniela',
      name: 'Daniela Morales',
      phone: '+56 9 1111 2208',
      whatsapp: '+56 9 1111 2208',
      instagram: '@danielamorales',
      joinedAt: _ago(days: 2),
    ),
    Customer(
      id: 'catalina',
      name: 'Catalina Silva',
      phone: '+56 9 1111 2209',
      whatsapp: '+56 9 1111 2209',
      address: 'Viña del Mar',
      joinedAt: _ago(days: 120),
      purchases: [
        _sale(
          id: 'c-catalina-1',
          number: 162,
          name: 'Catalina Silva',
          phone: '+56 9 1111 2209',
          at: _ago(days: 45),
          lines: const [_hoodie],
        ),
      ],
    ),
  ];
}
